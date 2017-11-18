require 'fileutils'
require_relative 'text_util'

class TextEditor
  def initialize(file_path, print_debug = false)
    @file_path = file_path
    FileUtils.touch(file_path) unless File.exist?(file_path)
    @print_debug = print_debug
  end

  def read()
    content = read_content()
    debug(content)
    content
  end

  def count_lines(content = nil)
    content = read_content() unless content
    content.chomp().lines.size()
  end
  
  def insert_line(line_num, line)
    lines = get_lines()
    validate_linum(line_num, lines.size() + 1)
    lines.insert(line_num - 1, line)
    debug(lines)
    content = lines.join("\n")
    write_content(content)
    content
  end

  def find_line(pattern)
    pattern = to_regexp(pattern)
    content = read_content()
    content.lines().each_with_index do |line, index|
      return index + 1 if pattern =~ line.chomp()
    end
    nil
  end

  def find_lines(pattern)
    pattern = to_regexp(pattern)
    content = read_content()
    lines = []
    content.lines().each_with_index().map() do |line, index|
      lines.push(index + 1) if pattern =~ line.chomp()
    end
    lines
  end

  def append_line(newline)
    lines = get_lines()
    lines.push(newline)
    write_content(lines.join("\n"))
  end

  def delete_line(line_num)
    lines = get_lines()
    validate_linum(line_num, lines.size())
    lines.delete_at(line_num - 1)
    write_content(lines.join("\n"))
  end

  def replace(target, word)
    content = read_content()
    content.gsub!(target, word)
    write_content(content)
    content
  end

  private

  def to_regexp(pattern)
    if pattern.is_a?(Regexp)
      pattern
    else
      TextUtil.to_regexpr(pattern.to_s())
    end
  end

  def read_content()
    File.read(@file_path)
  end

  def get_lines(content = nil)
    content = read_content() unless content
    content.chomp().lines().map!{ |line| line.chomp() }
  end

  def write_content(content)
    content = content + "\n" unless content.end_with?("\n")
    File.write(@file_path, content)
  end

  def validate_linum(linum, max_linum = nil)
    raise "Invalid line range: `#{linum}`" unless valid_range?(linum, max_linum)
  end

  def valid_range?(linum, max)
    linum > 0 && (!max || linum <= max)
  end

  def debug(data)
    puts data if @print_debug
  end
end
