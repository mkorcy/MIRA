require 'spec_helper'

feature 'View unpublished documents' do
  before do
    TuftsAudio.where(title: "Very unique title").destroy_all
    @production = TuftsAudio.new(title: 'Very unique title', description: 'eh?', creator: 'Fred')
    @production.push_to_production!

    @not_production = TuftsAudio.new(title: 'Very unique title', description: 'eh?', creator: 'Fred')
    @not_production.save!

    sign_in :admin
  end

  scenario 'with a TuftsAudio' do
    visit root_path
    click_link 'Unpublished objects'

    fill_in 'q',      with: 'Very unique title'
    click_button 'Search'

    page.should have_link('Very unique title', href: catalog_path(@not_production) )
    page.should_not have_link('Very unique title', href: catalog_path(@production) )
  end
end

feature "Finding self-deposited documents using facets" do
  let!(:self_deposit) { FactoryGirl.create(:self_deposit_pdf ) }
  after { self_deposit.destroy }
  before { sign_in :admin }

  it 'shows only the self-deposited docs' do
    visit unpublished_index_path
    within(".blacklight-deposit_method_ssi") do
      click_link 'self-deposit' 
    end
    page.should have_css('#documents .document', count: 1) # filtered out all but one
    page.should have_link(self_deposit.title, href: catalog_path(self_deposit))
  end
end

