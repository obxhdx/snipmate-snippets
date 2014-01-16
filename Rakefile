# The install task was stolen from RyanB
# http://github.com/ryanb/dotfiles

# encoding: utf-8

desc 'Generate snippets for html special chars entities'
task :html_special_chars do
  Rake::Task['generate_snippet_files'].invoke './html/special_chars.snippets'
end

desc 'Split single *.snippets file into multiple *.snippet files. Note: snippets must be separated by an empty line.'
task :generate_snippet_files, :input_file do |t, args|
  snippets_file = File.open(args[:input_file])
  snippets_dir  = File.dirname snippets_file

  contents = snippets_file.read
  snippets = contents.scan /^[^#]\w+\s(.*?)\s(.*?)\n$/m

  snippets.each do |s|
    file = "#{snippets_dir}/#{s[0]}.snippet"

    puts "Generating #{file}"
    File.open("#{file}", 'w+') { |f| f.write "#{s[1]}" }
  end
end

desc 'Install the snippets into snipmate snippets dir'
task :install => ['snippets_dir:find'] do
  replace_all = false
  Dir['*'].each do |file|
    next if %w[Rakefile].include? file

    if File.exist?(File.join(@snippets_dir, "#{file}"))
      if replace_all
        replace_file(file)
      else
        print "Overwrite #{File.join(@snippets_dir, file)}? [ynaq]"
        case $stdin.gets.chomp
        when 'a'
          replace_all = true
          replace_file(file)
        when 'y'
          replace_file(file)
        when 'q'
          exit
        end
      end
    else
      link_file(file)
    end
  end
end

def replace_file(file)
  link_file(file)
end

def link_file(file)
  puts "Copying #{@snippets_dir}/#{file}"
  cp_r File.join(FileUtils.pwd,file), @snippets_dir, :verbose => false
end

namespace :snippets_dir do
  desc 'Sets @snippets_dir dependent on which OS You run'
  task :find do
    vim_dir = File.join(ENV['VIMFILES'] || ENV['HOME'] || ENV['USERPROFILE'], RUBY_PLATFORM =~ /mswin|msys|mingw32/ ? 'vimfiles' : '.vim')
    pathogen_dir = File.join(vim_dir, 'bundle')
    @snippets_dir = File.directory?(pathogen_dir) ? File.join(pathogen_dir, 'snipmate.vim', 'snippets') : File.join(vim_dir, 'snippets')
    @snipmate_plugin_dir = File.directory?(pathogen_dir) ? File.join(pathogen_dir, 'snipmate.vim', 'plugin') : File.join(vim_dir, 'plugin')
  end

  desc 'Purge the contents of the vim snippets directory'
  task :purge => ['snippets_dir:find'] do
    puts 'Purging snippets directory...'
    rm_rf @snippets_dir, :verbose => false if File.directory? @snippets_dir
    mkdir @snippets_dir, :verbose => false
  end
end

desc 'Copy the snippets directories into ~/.vim/snippets'
task :deploy_local => ['snippets_dir:purge'] do
  Dir.foreach(".") do |f|
    cp_r f, @snippets_dir, :verbose => true if File.directory?(f) && f =~ /^[^\.]/
  end
  cp 'support_functions.vim', @snippets_dir, :verbose => true
end

task :support_functions => ['snippets_dir:find'] do
  ln_s File.join(FileUtils.pwd,'support_functions.vim'), @snipmate_plugin_dir, :force => true, :verbose => false
end

desc 'Alias for purge'
task :purge => ['snippets_dir:purge']

desc 'Alias for default task'
task :default => [:html_special_chars, :purge, :install, :support_functions]
