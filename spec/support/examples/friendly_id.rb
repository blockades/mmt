# frozen_string_literal: true

RSpec.shared_examples 'sluggable' do |field|
  it "assigns slug when #{field} changes" do
    expect(subject.slug).to be_nil
    subject.send("#{field}=", 'rand')
    expect{ subject.send(:adjust_slug) }.to change{ subject.slug }
  end
end
