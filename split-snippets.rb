SNIPPETS_DIR  = './javascript-jasmine'
SNIPPETS_FILE = '/javascript-jasmine.snippets'

contents = File.open(SNIPPETS_DIR+SNIPPETS_FILE).read
snippets = contents.scan /^#[A-Za-z ]+\ssnippet\s([a-z]+)\n(.*?)\n^$/m

snippets.each do |s|
  file = "#{SNIPPETS_DIR}/#{s[0]}.snippet"

  puts "Generating #{file}"
  File.open("#{file}", 'w+') { |f| f.write "#{s[1]}" }
end
