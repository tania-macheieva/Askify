module ApplicationHelper
  def inclination(count, one, many)
    return many if (count % 100).between?(11, 14)

    if count % 10 == 1
      then one
    else
      many
    end
  end
end
