# encoding=utf-8

module Bixi
  module Cache
    extend self

    def []=(key, value)
      store[key]        = value
      storage_time[key] = Time.now
    end

    def [](key)
      unless store[key] && (Time.now - storage_time[key] < expiry)
        store.delete(key)
        storage_time.delete(key)
      end
      store[key]
    end

    def expiry=(seconds)
      @expiry = seconds
    end

    def expiry
      @expiry ||= 300
    end

    private

    def store
      @store ||= {}
    end

    def storage_time
      @storage_time ||= {}
    end
  end
end