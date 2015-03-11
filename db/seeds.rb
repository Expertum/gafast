# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Adding administrative areas of Ukraine
    Oblast.create!( [
                  { :name => "місто Київ" },
                  { :name => "Автономна Республіка Крим" },
                  { :name => "Вінницька область" },
                  { :name => "Волинська область" },
                  { :name => "Дніпропетровська область" },
                  { :name => "Донецька область" },
                  { :name => "Житомирська область" },
                  { :name => "Закарпатська область" },
                  { :name => "Запорізька область" },
                  { :name => "Івано-Франківська область" },
                  { :name => "Київська область" },
                  { :name => "Кіровоградська область" },
                  { :name => "Луганська область" },
                  { :name => "Львівська область" },
                  { :name => "Миколаївська область" },
                  { :name => "Одеська область" },
                  { :name => "Полтавська область" },
                  { :name => "Рівненська область" },
                  { :name => "Сумська область" },
                  { :name => "Тернопільська область" },
                  { :name => "Харківська область" },
                  { :name => "Херсонська область" },
                  { :name => "Хмельницька область" },
                  { :name => "Черкасская область" },
                  { :name => "Чернігівська область" },
                  { :name => "Чернівецька область" },
    ])

    Filial.create!( name: "Main filial", contact_name: "Filial Director", telephone: "put telephone here")
    User.create!( name: "Administrator", email_address: "expertum.ave@gmail.com", administrator: true,role:"provizor", position:"Administrator",filial:Filial.find(1),password:"FirstAdminPass1word")
