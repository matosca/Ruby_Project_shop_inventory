require_relative('../db/sql_runner.rb')


class Manufacturer

  attr_reader :name, :country, :phone, :email, :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @country = options['country']
    @phone = options['phone']
    @email = options['email']
  end

  def save()
    sql = "INSERT INTO manufacturers (name, country, phone, email)
          VALUES ($1, $2, $3, $4)
          RETURNING id"
    values = [@name, @country, @phone, @email]
    manufacturer = SqlRunner.run(sql, values).first
    @id = manufacturer['id'].to_i
  end

  def update()
    sql = "UPDATE manufacturers
          SET (name, country, phone, email) = ($1, $2, $3, $4)
          WHERE id = $5"
    values = [@name, @country, @phone, @email]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM manufacturers
          WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.all()
    sql = "SELECT * FROM manufacturers"
    manufacturer_data = SqlRunner.run(sql)
    result = Manufacturer.map_items(manufacturer_data)
    return result
  end

  def self.delete_all()
    sql = "DELETE FROM manufacturers"
    SqlRunner.run(sql)
  end

  def self.find(id)
    sql = "SELECT * FROM manufacturers WHERE id = $1"
    values = [id]
    manufacturer = SqlRunner.run(sql, values).first
    result = Manufacturer.new(manufacturer)
    return result
  end

#Helper method for mapping
  def self.map_items(manufacturer_data)
    return manufacturer_data.map { |manufacturer| Manufacturer.new(manufacturer) }
  end
end
