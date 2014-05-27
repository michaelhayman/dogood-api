class AddNewVoteCachingColumn < ActiveRecord::Migration
  def change
    add_column :goods, :cached_weighted_score, :integer, :default => 0
    add_index  :goods, :cached_weighted_score
    add_column :votes, :vote_weight, :integer
  end
end
