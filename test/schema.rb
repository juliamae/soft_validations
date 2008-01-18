ActiveRecord::Schema.define(:version => 1) do
  create_table :employees, :force => true do |t|
    t.column :last_name,  :string
    t.column :first_name, :string
  end
end
