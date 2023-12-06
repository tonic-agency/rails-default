ActiveAdmin.register Delayed::Job, :as  => "DelayedJob" do
  menu parent: 'Dev', label: 'Job Queue'
end