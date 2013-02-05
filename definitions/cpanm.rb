# -*- coding: utf-8 -*-
#
# Cookbook Name:: cpan_modules
# Recipe:: default
#
# Copyright 2013, Naoya Ito
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
define :cpanm, :force => nil do
  bash "install-#{params[:name]}" do
    user node['user']['name']
    cwd node['user']['home']
    environment "HOME" => node['user']['home']

    if params[:force]
      code <<-EOC
        source ~/perl5/perlbrew/etc/bashrc
        cpanm --force #{params[:name]}
      EOC
    else
      code <<-EOC
        source ~/perl5/perlbrew/etc/bashrc
        cpanm #{params[:name]}
      EOC
    end

    ## FIXME: not to work correctly
    not_if <<-EOC
      su - #{node['user']['name']} &&
      source #{node['user']['home']}/perl5/perlbrew/etc/bashrc &&
      perl -m#{params[:name]} -e ''
    EOC
  end
end
