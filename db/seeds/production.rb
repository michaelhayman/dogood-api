include Sprig::Helpers

Category.destroy_all
Reward.destroy_all

ActiveRecord::Base.connection.reset_pk_sequence!(Category.table_name)
ActiveRecord::Base.connection.reset_pk_sequence!(Reward.table_name)

sprig [ Category, Reward ]
