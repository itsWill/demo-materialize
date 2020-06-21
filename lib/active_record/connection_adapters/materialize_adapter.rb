require "pg"


require 'active_record'

module ActiveRecord
  module ConnectionHandling
    def materialize_connection(config)
      conn_params = config.symbolize_keys.compact

      conn_params[:user] = conn_params.delete(:username) if conn_params[:username]
      conn_params[:dbname] = conn_params.delete(:database) if conn_params[:database]

      valid_conn_param_keys = PG::Connection.conndefaults_hash.keys + [:requiressl]
      conn_params.slice!(*valid_conn_param_keys)

      conn = PG.connect(conn_params)

      ConnectionAdapters::MaterializeAdapter.new(conn, logger, config)
    end
  end

  module ConnectionAdapters
    ADAPTER_NAME = "Materialize"

    class MaterializeAdapter < AbstractAdapter
      def self.database_exists?(config)
        !!ActiveRecord::Base.materialize_connection(config)
      rescue ActiveRecord::NoDatabaseError
        false
      end

      def active?
        @connection.query "SELECT 1"
        true
      rescue PG::Error
        false
      end

      def preventing_writes?
        true
      end

      def reset!
        clear_cache!
        reset_transaction
      end

      def disconnect!
        super
        @connection.close rescue nil
      end

      def supports_json?
        true
      end

      def suppports_views?
        true
      end
    end

    module DatabaseStatements
      def execute(sql, name = nil)
        log(sql, name) do
          ActiveSupport::Dependencies.interlock.permit_concurrent_loads do
            @connection.async_exec(sql)
          end
        end
      end

      def exec_query(sql, name = "SQL", binds = [], prepare: false)
        result = execute(sql)
        column_types = {
          "id" => Type::Integer,
          "total" => Type::Integer
        }
        build_result(columns: result.fields, rows: result.values, column_types: column_types)
      end

      def column_definitions(table_name)
        result = execute("SHOW COLUMNS FROM #{table_name}")
        result.values.each_with_object([]) do |value, results|
          results  << Hash[result.fields.zip(value)]
        end
      end

      def new_column_from_field(table_name, field)
        sql_type_metadta = ActiveRecord::ConnectionAdapters::SqlTypeMetadata.new(
          sql_type: "int8",
          type: "int8",
          limit: 8,
          precision: 8,
          scale: 8
        )
        Column.new(field["Field"], nil, sql_type_metadta, field["Nullable"] == "YES")
      end
    end

    module SchemaStatements
      def data_source_sql(name=nil, type: nil)
        "SHOW VIEWS"
      end

      def primary_keys(table_name)
        [""]
      end
    end
  end
end
