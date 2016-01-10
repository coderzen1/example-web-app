User.create(email: "admin@infinum.hr", password: "12345678", role: 0)

7.times do |i|
  company = Company.create(name: "Company#{i}", token: "PTV_Loc_Infinum_BY1FII2CD", language: "English", dashboard_colors: ["rgb(43, 0, 107)", "rgb(96, 64, 144)", "rgb(149, 128, 181)"],
    address_attributes: {
      street: "Strojarska",
      city: "Zagreb",
      number: "#{22 + i}",
      zip_code: "10000"
    })

  company.users.create(email: "user#{i + 1}@infinum.hr", password: "12345678", role: 1)

  3.times do |i|
    location = company.locations.create(name: "Location#{i + 1}", longitude: 23.232323232323, latitude: 45.2323232323, custom_fields:["Weight", "Height", "Type"],
      address_attributes: {
        street: "Strojarska",
        city: "Zagreb",
        number: "#{22 + i}",
        zip_code: "10000"
      })
    location.arrivals.create(pta: Time.now + 10000, vehicle_type: 1, custom_fields: {"Weight": "22", "Height": "23", "Type": "2" } )
  end
end
