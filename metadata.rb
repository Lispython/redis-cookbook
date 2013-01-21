name             "redis"
maintainer       "Alexandr Lispython"
maintainer_email "alex@obout.ru"
license          "BSD, see LICENSE for more details."
description      "Install/Configures redis service"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.2"


%w[ debian ubuntu].each do |os|
  supports os
end
