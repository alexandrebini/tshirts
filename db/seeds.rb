10.times do |i|
  t_shirt = TShirt.new({
    title: "Shirt #{ i }",
    gender: "m,f",
    description: "aaaaaaaaaa",
    source_url: 'http://aaa.com.br',
    photos: [
      Photo.new(data: File.open())
    ]
  })

  puts t_shirt.title, t_shirt.slug
end