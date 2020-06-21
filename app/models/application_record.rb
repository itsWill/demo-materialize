class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  connects_to shards: {
    materialize: { reading: :materialize },
    default: { writing: :mysql, reading: :mysql}
  }
end
