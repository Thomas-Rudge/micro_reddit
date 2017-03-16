class RemoveSubjectTypeFromVotes < ActiveRecord::Migration[5.0]
  def change
    remove_column :votes, :subject_type, 'string'
  end
end
