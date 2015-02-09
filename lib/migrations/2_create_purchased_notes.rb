Sequel.migration do
  change do
    create_table(:purchased_notes) do
      primary_key :id
      Time :purchased_at
      Integer :loan_id
    end
  end
end
