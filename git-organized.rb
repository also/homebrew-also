class GitOrganized < Formula
  url "git@github.com:also/git-organized.git", :using => :git, :revision => "6090c03a8d6d79bf9d7eea7b4fa73959a9bffd00"
  version "0.1.0"

  resource "yarn" do
    url "https://github.com/yarnpkg/yarn/releases/download/v1.6.0/yarn-v1.6.0.tar.gz"
    sha256 "a57b2fdb2bfeeb083d45a883bc29af94d5e83a21c25f3fc001c295938e988509"
  end

  resource "node" do
    url "https://nodejs.org/dist/v10.15.3/node-v10.15.3-darwin-x64.tar.gz"
    sha256 "7a5eaa1f69614375a695ccb62017248e5dcc15b0b8edffa7db5b52997cf992ba"
  end

  def install
    resource("node").stage(prefix/"node")

    ENV.append_path("PATH", prefix/"node"/"bin")
      
    resource("yarn").stage do
      system "bin/yarn", "--cwd", buildpath
      system "bin/yarn", "--cwd", buildpath, "build"
      system "bin/yarn", "--cwd", buildpath, "--prod", "--modules-folder", prefix/"node_modules"
    end

    prefix.install(Dir["lib/*"])

    (bin/"git-organized").write("#!/bin/bash\nexec #{prefix/"node"/"bin"/"node"} #{prefix/"index.js"}")
  end

  test do

  end
end
