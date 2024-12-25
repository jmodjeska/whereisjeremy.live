# frozen_string_literal: true

require_relative '../location'

class Spec
end

def setup_location
  test_ranges = %w[
    [2022-01-01 2022-12-31 Beijing]
    [2023-12-30 2024-01-04 Hanoi]
    [2078-01-02 2078-05-01 Seattle]
  ]

  stub_const('DATE_RANGES', test_ranges)
  stub_const('DEFAULT_CITY', 'Madrid')
  stub_const('VISITS_TABLE_CITY', 'Seattle')

  @s = Spec.new.extend(Location)
end

describe 'Location tests' do
  it 'returns the correct test city' do
    t = '2021-05-29'
    expect(@s.lookup(t)).to eq 'Portland'
  end

  it 'returns the correct test city - Madrid' do
    t = '2020-12-31'
    expect(@s.lookup(t)).to eq 'Madrid'
  end

  it 'returns the default city when no date range found - past date' do
    t = '2019-01-04'
    expect(@s.lookup(t)).to eq 'Seattle'
  end

  it 'returns the default city when no date range found - future date' do
    t = '2433-07-14'
    expect(@s.lookup(t)).to eq 'Seattle'
  end
end
