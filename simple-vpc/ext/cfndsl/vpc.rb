require 'netaddr'


def extended_tags(tags, map)
  new_tags = tags.clone
  new_tags += (map.collect { |k, v| { 'Key' => k, 'Value' => v } })
  return new_tags
end
