name = "open_id_authentication"

Gem::Specification.new name, "0.1.0" do |s|
  s.summary = "Provides a thin wrapper around the excellent ruby-openid gem from JanRan"
  s.authors = ["David Heinemeier Hansson"]
  s.email = "someone@example.com"
  s.homepage = "https://github.com/grosser/#{name}"
  s.files = `git ls-files`.split("\n")
  s.license = "MIT"
  s.add_runtime_dependency "rack-openid", ">= 0.2.1"
end
