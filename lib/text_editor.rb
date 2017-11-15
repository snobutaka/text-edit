require_relative 'text_util'

class TextEditor
  def initialize(file_path, print_debug = false)
    @file_path = file_path
    @print_debug
  end

  def read()
    content = read_content()
    debug(content)
    content
  end
  
  def insert_line(line_num, line)
    content = read_content()
    lines = content.lines().map!{ |line| line.chomp() }
    validate_linum(line_num, lines.size() + 1)
    lines.insert(line_num - 1, line)
    debug(lines)
    content = lines.join("\n")
    write_content(content)
    content
  end

  def find_line(pattern)
    pattern = to_regexrpr_if_string(pattern)
    content = read_content()
    content.lines().each_with_index do |line, linum|
      return linum + 1 if pattern =~ line
    end
    nil
  end

  private

  def to_regexrpr_if_string(pattern)
    if pattern.is_a?(Regexp)
      pattern
    else
      TextUtil.to_regexpr(pattern)
    end
  end

  def read_content()
    File.read(@file_path)
  end

  def write_content(content)
    content = content + "\n" unless content.end_with?("\n")
    File.write(@file_path, content)
  end

  def validate_linum(linum, max_linum = nil)
    unless valid_range(linum, max_linum)
      raise "Invalid line range: `#{linum}`" 
    end
  end

  def valid_range(linum, max)
    linum > 0 && (!max || linum <= max)
  end

  def debug(data)
    puts data if @print_debug
  end
end
