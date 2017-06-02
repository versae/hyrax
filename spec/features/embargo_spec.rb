RSpec.feature 'embargo' do
  let(:user) { create(:user) }
  before do
    sign_in user
  end
  describe 'creating an embargoed object' do
    before do
      visit '/'
    end

    let(:future_date) { 5.days.from_now }
    let(:later_future_date) { 10.days.from_now }

    # Pending revision to work in hyrax
    # TODO: https://github.com/samvera-labs/hyrax/issues/1123
    xit 'can be created, displayed and updated', :workflow do
      click_link 'New Generic Work'
      fill_in 'Title', with: 'Embargo test'
      choose 'Embargo'
      fill_in 'generic_work_embargo_release_date', with: future_date
      select 'Private', from: 'Restricted to'
      select 'Open Access', from: 'then open it up to'
      click_button 'Create Generic work'

      # chosen embargo date is on the show page
      expect(page).to have_content(future_date.to_date.to_formatted_s(:standard))

      click_link 'Edit This Generic Work'
      click_link 'Embargo Management Page'

      expect(page).to have_content('This work is under embargo.')
      expect(page).to have_xpath("//input[@name='generic_work[embargo_release_date]' and @value='#{future_date.to_datetime.iso8601}']") # current embargo date is pre-populated in edit field

      fill_in 'until', with: later_future_date.to_s

      click_button 'Update Embargo'
      expect(page).to have_content(later_future_date.to_date.to_formatted_s(:standard))
    end
  end

  describe 'managing embargoes' do
    let(:user) { create(:user, groups: ['admin']) }

    it 'shows lists of objects under lease' do
      visit '/embargoes'
      expect(page).to have_content 'Manage Embargoes'
    end
  end
end
