# encoding: utf-8
require 'spec_helper'

describe S3MPI::Example do
  let (:object) { 5 }

  it 'expects object to be' do
    expect(object).to eql(5)
  end

end

