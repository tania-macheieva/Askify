module UsersHelper
  def safe_external_uri(url)
    return nil if url.blank?

    uri = URI.parse(url)
    uri if %w[http https].include?(uri.scheme)
  rescue URI::InvalidURIError
    nil
  end

  def safe_external_link(url)
    uri = safe_external_uri(url)
    uri&.to_s
  end

  def safe_github_url(url)
    uri = safe_external_uri(url)
    uri && uri.host&.downcase&.end_with?("github.com") ? uri.to_s : nil
  end

  def safe_linkedin_url(url)
    uri = safe_external_uri(url)
    uri && uri.host&.downcase&.include?("linkedin.com") ? uri.to_s : nil
  end
end
