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
      EventKeys.get_user_count(region_id)
    end

    def tabcount(request_id)
      EventKeys.get_tab_count(self.current, request_id)
    end
  end
end
