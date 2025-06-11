module UsersHelper
  def safe_external_link(url, options = {})
    return nil if url.blank?

    begin
      uri = URI.parse(url)
      return nil unless %w[http https].include?(uri.scheme)

      uri.to_s
    rescue URI::InvalidURIError
      nil
    end
  end

  def safe_github_url(url)
    safe_url = safe_external_link(url)
    return nil unless safe_url

    uri = URI.parse(safe_url)
    uri.host&.downcase&.end_with?("github.com") ? safe_url : nil
  end

  def safe_linkedin_url(url)
    safe_url = safe_external_link(url)
    return nil unless safe_url

    uri = URI.parse(safe_url)
    uri.host&.downcase&.include?("linkedin.com") ? safe_url : nil
  end
end
