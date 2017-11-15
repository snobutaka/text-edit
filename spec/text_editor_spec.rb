require 'spec_helper'
require 'text_editor'
require 'tempfile'

describe TextUtil do
  it "reads text file" do
    content = "Hello world!"
    tempfile = create_tmp_file(content)

    editor = TextEditor.new(tempfile)
    expect(editor.read()).to eq content
  end
end

describe TextUtil do
  it "finds line" do
    content = ["one", "two", "three"].join("\n")
    tempfile = create_tmp_file(content)

    editor = TextEditor.new(tempfile)
    expect(editor.find_line("one")).to eq 1
    expect(editor.find_line("two")).to eq 2
    expect(editor.find_line("three")).to eq 3
    expect(editor.find_line("four")).to eq nil
  end
end

describe TextUtil do
  it "inserts a line to file" do
    content = "one\n"
    tempfile = create_tmp_file(content)

    editor = TextEditor.new(tempfile)
    expect(editor.insert_line(2, "two")). to eq "one\ntwo"
    expect(File.read(tempfile)).to eq "one\ntwo\n"
  end
end

describe TextUtil do
  it "finds line and insert line" do
    content = ["one","two","four"].join("\n")
    tempfile = create_tmp_file(content)

    editor = TextEditor.new(tempfile)
    linum = editor.find_line("four")
    expect(editor.insert_line(linum, "three")).to eq "one\ntwo\nthree\nfour"
    expect(File.read(tempfile)).to eq "one\ntwo\nthree\nfour\n"
  end
end

def create_tmp_file(content)
  tempfile = Tempfile.new(self.class().name())
  File.write(tempfile, content)
  tempfile
end
