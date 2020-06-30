git clone https://github.com/etsauer/openshift-playbooks.git
cd openshift-playbooks
git checkout copedia
bundle install
gem env
bundle exec jekyll build
