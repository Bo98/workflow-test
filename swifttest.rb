class Swifttest < Formula
  desc "Incrementally update/translate your Strings files"
  homepage "https://github.com/Flinesoft/BartyCrouch"
  url "https://github.com/Flinesoft/BartyCrouch.git",
      tag:      "4.10.0",
      revision: "a832f73a8b07b6875d055d9b2963d5b2eb157e54"
  license "MIT"
  head "https://github.com/Flinesoft/BartyCrouch.git", branch: "main"

  depends_on "swift" => :build
  depends_on :xcode => :build
  depends_on :macos

  def install
    system "make", "install", "prefix=#{prefix}"
    system "ls", "-lR", ".build"
  end

  test do
    (testpath/"Test.swift").write <<~EOS
      import Foundation

      class Test {
        func test() {
            NSLocalizedString("test", comment: "")
        }
      }
    EOS

    (testpath/"en.lproj/Localizable.strings").write <<~EOS
      /* No comment provided by engineer. */
      "oldKey" = "Some translation";
    EOS

    system bin/"bartycrouch", "update"
    assert_match '"oldKey" = "', File.read("en.lproj/Localizable.strings")
    assert_match '"test" = "', File.read("en.lproj/Localizable.strings")
  end
end
