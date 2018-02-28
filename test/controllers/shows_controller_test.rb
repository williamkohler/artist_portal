require 'test_helper'

class ShowsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @standard_user = users(:standard)
    @admin = users(:admin)
    @show = shows(:one)
    @contact = contacts(:bill)
    @venue = venues(:sinclair)
    @radiohead = artists(:radiohead)
    @new_show = Show.new(artist_id: @radiohead.id,
                         backend: 'flat guarantee',
                         agent: 'Agent Name',
                         capacity: '250',
                         contract_due: Date.today - 90,
                         fee: 10_000,
                         gross_potential: '$10,000',
                         number_of_shows: 1,
                         promoter_id: @contact.id,
                         production_id: @contact .id,
                         set_length: 'seventy-five minutes',
                         start_date: Date.today,
                         start_time: '9pm',
                         ticket_scale: '$20.00',
                         venue_id: @venue.id)
  end

  test 'show should be valid' do
    assert @new_show.valid?
  end

  test 'should destroy shows when artist is destroyed' do
    Show.create!(agent: 'Bill Kohler',
                 artist_id: @radiohead.id,
                 backend: 'flat guarantee',
                 capacity: '250',
                 contract_due: Date.today - 90,
                 fee: 10_000,
                 gross_potential: '$10,000',
                 number_of_shows: 1,
                 promoter_id: @contact.id,
                 production_id: @contact.id,
                 set_length: 'seventy-five minutes',
                 start_date: Date.today,
                 start_time: '7pm',
                 ticket_scale: '$20.00 (advance / $25.00 (day of show)',
                 venue_id: @venue.id)
    assert Show.where(artist_id: @radiohead.id).any?
    @radiohead.destroy
    assert_not Show.where(artist_id: @radiohead.id).any?
    assert_not Show.where(artist_id: @radiohead.id).any?
  end

  test 'users should be able to create new shows' do
    log_in_as @admin
    get new_show_path
    assert_difference 'Show.count', 1 do
      post shows_path, params: { show: { agent: 'Agent Name',
                                         backend: 'flat guarantee',
                                         artist_id: @radiohead.id,
                                         capacity: '250',
                                         contract_due: Date.today - 90,
                                         fee: 10000,
                                         gross_potential: '$10,000',
                                         number_of_shows: 1,
                                         promoter_id: @contact.id,
                                         production_id: @contact.id,
                                         set_length: 'seventy-five minutes',
                                         start_date: Date.today,
                                         start_time: '7pm',
                                         ticket_scale: '$20.00 (advance'\
                                                       '/ $25.00 (day of show)',
                                         venue_id: @venue.id } }
    end
  end

  test 'admin users should be able to delete shows' do
    log_in_as @admin
    assert_difference 'Show.count', -1 do
      delete show_path @show
    end
  end

  test 'standard users should not be able to delete shows' do
    log_in_as @standard_user
    assert_no_difference 'Show.count' do
      delete show_path @show
    end
  end
end
