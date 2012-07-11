require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe 'routing to atrium/collections' do
  extend BeRouted
  be_routed(:get, '/atrium/collections',
    :controller => 'atrium/collections',
    :action => 'index'
  )
  be_routed(:get, '/atrium/collections/new',
    :controller => 'atrium/collections',
    :action => 'new'
  )
  be_routed(:post, '/atrium/collections',
    :controller => 'atrium/collections',
    :action => 'create'
  )
  be_routed(:get, '/atrium/collections/2',
    :controller => 'atrium/collections',
    :action => 'show', :id => '2'
  )
  be_routed(:get, '/atrium/collections/2/edit',
    :controller => 'atrium/collections',
    :action => 'edit', :id => '2'
  )
  be_routed(:put, '/atrium/collections/2',
    :controller => 'atrium/collections',
    :action => 'update', :id => '2'
  )
  be_routed(:delete, '/atrium/collections/2',
    :controller => 'atrium/collections',
    :action => 'destroy', :id => '2'
  )
end
