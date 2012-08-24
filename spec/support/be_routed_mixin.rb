module BeRouted
  def be_routed(method_name,path, params)
    it "routes #{method_name.to_s.upcase} #{path} to #{params.inspect}" do
      {method_name.to_sym => path}.should route_to(params)
    end
  end
end
