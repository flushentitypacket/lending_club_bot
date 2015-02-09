Sequel.migration do
  change do
    create_table(:loans) do
      primary_key :id
      String :json, text: true
    end
  end
end
