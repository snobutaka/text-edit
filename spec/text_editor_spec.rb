require 'spec_helper'
require 'text_editor'
require 'tmpdir'
require 'tempfile'

describe TextEditor do
  it "reads text file" do
    content = "Hello world!"
    tempfile = create_tmp_file(content)

    editor = TextEditor.new(tempfile)
    expect(editor.read()).to eq content
  end
end

describe TextEditor do
  it "finds line by strings" do
    content = ["one", "two", "three"].join("\n")
    tempfile = create_tmp_file(content)

    editor = TextEditor.new(tempfile)
    expect(editor.find_line("one")).to eq 1
    expect(editor.find_line("two")).to eq 2
    expect(editor.find_line("three")).to eq 3
  end
end

describe TextEditor do
  it "finds line by regular expressions" do
    content = ["one", "two", "three"].join("\n")
    tempfile = create_tmp_file(content)

    editor = TextEditor.new(tempfile)
    expect(editor.find_line(/.*n.*/)).to eq 1
    expect(editor.find_line(/.*w.*/)).to eq 2
    expect(editor.find_line(/.*hre.*/)).to eq 3
  end
end

describe TextEditor do
  it "returns nil if cannot find line" do
    content = ["one", "two", "three"].join("\n")
    tempfile = create_tmp_file(content)

    editor = TextEditor.new(tempfile)
    expect(editor.find_line("four")).to eq nil
  end
end

describe TextEditor do
  it "finds lines" do
    tempfile = create_tmp_file(["one", "two", "three"].join("\n"))
    editor = TextEditor.new(tempfile)
    
    lines = editor.find_lines(/.*e.*/)
    expect(lines).to eq [1, 3]

    lines = editor.find_lines("four")
    expect(lines).to eq []
  end
end

describe TextEditor do
  it "inserts a line to file" do
    content = "one\n"
    tempfile = create_tmp_file(content)

    editor = TextEditor.new(tempfile)
    expect(editor.insert_line(2, "two")). to eq "one\ntwo"
    expect(File.read(tempfile)).to eq "one\ntwo\n"
  end
end

describe TextEditor do
  it "finds line and inserts line" do
    content = ["one","two","four"].join("\n")
    tempfile = create_tmp_file(content)

    editor = TextEditor.new(tempfile)
    linum = editor.find_line("four")
    inserted_content = editor.insert_line(linum, "three")

    expected = ["one", "two", "three", "four"].join("\n")
    expect(inserted_content).to eq expected
    expect(File.read(tempfile)).to eq expected + "\n"
  end
end

describe TextEditor do
  it "counts the number of lines" do
    tempfile = create_tmp_file(["one", "two", "three"].join("\n"))
    expect(TextEditor.new(tempfile).count_lines()).to eq 3

    tempfile = create_tmp_file(["one", "two", "three"].join("\n") + "\n")
    expect(TextEditor.new(tempfile).count_lines()).to eq 3
  end
end

describe TextEditor do
  it "creates file if given file does not exist" do
    Dir.mktmpdir() do |dir|
      test_file = File.join(dir, "test.txt")
      expect(File.exist?(test_file)).to be_falsey
      
      editor = TextEditor.new(test_file)
      expect(File.exist?(test_file)).to be_truthy
      expect(editor.read()).to eq ""
    end
  end
end

describe TextEditor do
  it "appends a line" do
    tempfile = create_tmp_file(["one", "two"].join("\n"))
    TextEditor.new(tempfile).append_line("three")
    expect(File.read(tempfile)).to eq ["one", "two", "three"].join("\n") + "\n"
  end
end

describe TextEditor do
  it "deletes a line" do
    tempfile = create_tmp_file(["one", "two", "three"].join("\n"))
    TextEditor.new(tempfile).delete_line(2)
    expect(File.read(tempfile)).to eq ["one", "three"].join("\n") + "\n"
  end
end

describe TextEditor do
  it "fails to delete line if line number is out of ranse" do
    tempfile = create_tmp_file(["one", "two", "three"].join("\n"))
    editor = TextEditor.new(tempfile)
    expect{editor.delete_line(0)}.to raise_error(RuntimeError, /Invalid line range: `\d+`/)
    expect{editor.delete_line(4)}.to raise_error(RuntimeError, /Invalid line range: `\d+`/)
  end
end

describe TextEditor do
  it "replaces words in file" do
    tempfile = create_tmp_file(["one", "two", "three"].join("\n"))
    TextEditor.new(tempfile).replace("w", "a")
    expect(File.read(tempfile)).to eq ["one", "tao", "three"].join("\n") + "\n"
  end
end

def create_tmp_file(content)
  tempfile = Tempfile.new(self.class().name())
  File.write(tempfile, content)
  tempfile
end
