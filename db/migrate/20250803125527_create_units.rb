class CreateUnits < ActiveRecord::Migration[7.2]
  def change
    create_table :units do |t|
      t.timestamps(null: false)
      t.string(:name, null: false, default: "")
      t.decimal(:position_x, null: false, default: 0)
      t.decimal(:position_y, null: false, default: 0)
    end

    add_index(:units, :name)
    add_index(:units, :position_x)
    add_index(:units, :position_y)
  end
end
