require_relative '../spec_helper'

describe GeoEngineer::Resources::AwsAlbTargetGroup do
  let(:alb_client) { AwsClients.alb }

  common_resource_tests(described_class, described_class.type_from_class_name)

  before { alb_client.setup_stubbing }

  describe "#_fetch_remote_resources" do
    it 'should create list of hashes from returned AWS SDK' do
      alb_client.stub_responses(
        :describe_target_groups,
        {
          target_groups: [
            {
              target_group_arn: "targetgroup/foo/bar-baz",
              port: 443,
              protocol: "HTTPS",
              vpc_id: "vpc-1"
            },
            {
              target_group_arn: "targetgroup/foo/test-test",
              port: 80,
              protocol: "HTTP",
              vpc_id: "vpc-1"
            }
          ]
        }
      )
      remote_resources = GeoEngineer::Resources::AwsAlbTargetGroup._fetch_remote_resources(nil)
      expect(remote_resources.length).to eq 2
    end
  end
end
