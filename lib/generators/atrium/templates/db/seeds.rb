# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

#############################################
# User Configuration
#############################################
email= "test@test.com"
if User.find_by_email(email).nil?
  user= User.create(:email => email, :password => "password", :password_confirmation => "password")
else
  user=  User.find_by_email(email)
end
puts "user created: #{user.inspect}"

#############################################
# Collection Configuration
#############################################

collection= Atrium::Collection.create
search_facet= Atrium::Search::Facet.create([{:name=> "format", :atrium_collection_id=> collection.id}])
puts "collection created: #{collection.inspect}, search_facet: #{search_facet.inspect}"
collection2=Atrium::Collection.create

#############################################
# Exhibit Configuration
#############################################
exhibit= Atrium::Exhibit.create([{:set_number=> 1, :atrium_collection_id=> collection.id, :label=> "Exhibit 1"}])
exhibit2= Atrium::Exhibit.create([{:set_number=> 1, :atrium_collection_id=> collection2.id, :label=> "Exhibit 1"}])
puts "exhibit created: #{exhibit.inspect}"
facet1=Atrium::BrowseLevel.create([{:atrium_exhibit_id=>1, :level_number=>1, :solr_facet_name=>'pub_date', :label=>'Publication Year'}])
facet2=Atrium::BrowseLevel.create([{:atrium_exhibit_id=>1, :level_number=>2, :solr_facet_name=>'language_facet', :label=>'Language'}])

########################################################################
# Add some description to solr which can be used to link to collection
########################################################################
Blacklight.solr.delete_by_id("desc_solr:1")
Blacklight.solr.delete_by_id("desc_solr:2")
Blacklight.solr.delete_by_id("desc_solr:3")
Blacklight.solr.commit

doc1= {
      :id                          => "desc_solr:1",
      :format                      => "Description",
      :active_fedora_model_s       => "Description",
      :title_t                     => "Land Office Bank Currency",
      :title_facet                 => "Land Office Bank Currency",
      :title_s                     => "Land Office Bank Currency",
      :page_display_s              => "newpage",
      :page_display_t              => "newpage",
      :description_content_s       => "<p style=\"margin-top: 0px; margin-right: 0px; margin-bottom: 1em; margin-left: 0px; padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; \"><span class=\"Apple-style-span\" style=\"color: rgb(51, 51, 51); font-family: Verdana, 'Lucida Grande', 'Lucida Sans Unicode', Arial, sans-serif; font-size: 11px; line-height: 15px; \">Very few colonists had liquid assets as most settlers were small farmers or local merchants holding their wealth as land or in the form of perishable commodities. This situation inhibited investment and economic development. In order to assist people in obtaining liquidity several colonies instituted &quot;Land Office Banks.&quot; The bank was operated by the colony with the consent of the Governor and the Board of Trade in London. Basically, a colony would print emissions of currency called &quot;Land Office&quot; notes. In several colonies the notes were allotted to local town or county boards. Property owners could then apply to their local board for a loan, usually up to &pound;100 offering as collateral a portion of their property that was assessed at twice the value of the loan. The individual was required to pay off the loan with interest over a prescribed period of time.</span></p>"
    }


doc2= {
      :id                          => "desc_solr:2",
      :format                      => "Description",
      :active_fedora_model_s       => "Description",
      :title_t                     => "Description 2",
      :title_facet                 => "Description 2",
      :title_s                     => "Description 2",
      :page_display_s              => "samepage",
      :page_display_t              => "samepage",
      :description_content_s       => "this is the actually description of the essay"
    }


doc3= {
      :id                          => "desc_solr:3",
      :format                      => "Description",
      :active_fedora_model_s       => "Description",
      :title_t                     => "Description 3",
      :title_facet                 => "Description 3",
      :title_s                     => "Description 3",
      :page_display_s              => "newpage",
      :page_display_t              => "newpage",
      :description_content_s       => "this is the actually description of the essay"
    }

Blacklight.solr.add doc1
Blacklight.solr.add doc2
Blacklight.solr.add doc3
Blacklight.solr.commit