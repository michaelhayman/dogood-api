include Sprig::Helpers

Category.destroy_all

ActiveRecord::Base.connection.reset_pk_sequence!(Category.table_name)

sprig [Category]
