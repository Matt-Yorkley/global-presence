class Region
  REGION_NAMES = {
    dev: "Localhost, Nowhere",
    ams: "Amsterdam, Netherlands",
    cdg: "Paris, France",
    fra: "Frankfurt, Germany",
    hkg: "Hong Kong",
    lhr: "London, United Kingdom",
    maa: "Chennai (Madras), India",
    nrt: "Tokyo, Japan",
    scl: "Santiago, Chile",
    sin: "Singapore",
    syd: "Sydney, Australia",
    yyz: "Toronto, Canada",
    dfw: "Dallas, Texas (US)",
    sjc: "Sunnyvale, California (US)",
    sea: "Seattle, Washington (US)",
    ord: "Chicago, Illinois (US)",
    iad: "Ashburn, Virginia (US)",
    lax: "Los Angeles, California (US)",
    ewr: "Secaucus, NJ (US)",
    gru: "São Paulo",
    mad: "Madrid, Spain",
    mia: "Miami, Florida (US)",
    vin: "Virginia (US)"
  }

  class << self
    def current
      ENV.fetch("FLY_REGION", "dev")
    end

    def deployed_regions
      ENV.fetch("DEPLOYED_REGIONS", "dev,dev,dev,dev,dev,dev").split(",")
    end

    def human_name(region_id = nil)
      REGION_NAMES[(region_id || current).to_sym] || "Not found!? That's weird..."
    end

    def usercount(region_id)
      Rails.cache.read("REGION:#{region_id}:USERCOUNT", raw: true)
    end

    def tabcount(request_id)
      Rails.cache.read("REGION:#{self.current}:USERTABS:#{request_id}", raw: true)
    end
  end
end
