# frozen_string_literal: true

# source https://gist.github.com/BryanSchuetz/2ee8c115096d7dd98f294362f6a667db
module Jekyll
  module CacheBust
    class CacheDigester
      require "digest/md5"

      attr_accessor :file_name, :directory

      def initialize(file_name:, directory: nil)
        self.file_name = file_name
        self.directory = directory
      end

      def digest!
        [file_name, "?", Digest::MD5.hexdigest(file_contents)].join
      end

      private

      def directory_files_content
        target_path = File.join(directory, "**", "*")
        Dir[target_path].map { |f| File.read(f) unless File.directory?(f) }.join
      end

      def file_content
        FIle.read(file_name)
      end

      def file_contents
        directory? ? file_content : directory_files_content
      end

      def directory?
        directory.nil?
      end
    end

    def bust_css_cache(file_name)
      CacheDigester.new(:file_name => file_name, :directory => "assets/stylesheets").digest!
    end
  end
end

Liquid::Template.register_filter(Jekyll::CacheBust)
