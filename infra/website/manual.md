#### **CloudFront, S3 배포하기**

```bash
cd ./infra/website
terraform init
terraform apply -var="profile=YOUR_USER_NAME" -var="domain_name=YOUR_DOMAIN"
```

| 파일명                    | 설명                                                     | 주요 구성 요소                                                                                                                                                                                                                   |
|---------------------------|----------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `_.datasource.acm.tf`     | AWS ACM 인증서 데이터 조회                               | - `data "aws_acm_certificate" "acm"`: 인증서 데이터 조회 선언<br>- `domain = var.domain_name`: 조회할 도메인 이름 지정<br>- `statuses = ["PENDING_VALIDATION", "ISSUED"]`: 조회할 인증서 상태 지정                                  |
| `_.datasource.zone.tf`    | AWS Route 53 호스팅 영역 데이터 조회                     | - `data "aws_route53_zone" "zone"`: 호스팅 영역 데이터 조회 선언<br>- `name = "${var.domain_name}."`: 조회할 호스팅 영역 이름 지정                                                                                                 |
| `_.providier.tf`          | AWS 프로바이더 설정                                      | - `provider "aws"`: AWS 프로바이더 선언<br>- `profile = var.profile`: 사용할 AWS CLI 프로필 지정<br>- `region = var.region`: 사용할 AWS 리전 지정                                                                                 |
| `_.variables.tf`          | Terraform 변수 정의                                      | - `variable "profile"`, `variable "region"`, `variable "domain_name"`: AWS CLI 프로필 이름, AWS 리전, 도메인 이름 변수 정의                                                                                                       |
| `cloudfront_acm.tf`       | AWS Route 53 A 레코드 생성                               | - `resource "aws_route53_record" "acm"`: A 레코드 생성 선언<br>- `zone_id = data.aws_route53_zone.zone.id`: 호스팅 영역 ID 지정<br>- `name = var.domain_name`: 레코드 이름 지정<br>- `type = "A"`: 레코드 타입 지정               |
| `cloudfront_oac.tf`       | AWS CloudFront Origin Access Control 생성                | - `resource "aws_cloudfront_origin_access_control" "cf_dist_oac"`: OAC 생성 선언<br>- `name`, `description`, `origin_access_control_origin_type`, `signing_behavior`, `signing_protocol`: OAC 속성 설정                            |
| `cloudfront.tf`           | AWS CloudFront 배포 생성                                 | - `resource "aws_cloudfront_distribution" "cf_dist"`: CloudFront 배포 생성 선언<br>- `enabled`, `price_class`, `aliases`, `is_ipv6_enabled`, `default_root_object`, `origin`, `default_cache_behavior`, `restrictions`, `viewer_certificate`, `custom_error_response`, `depends_on`: 배포 속성 설정 |
| `s3_bucket_policy.tf`      | AWS S3 버킷 정책 생성                                    | - `resource "aws_s3_bucket_policy" "bucket_policy"`: S3 버킷 정책 생성 선언<br>- `bucket`, `policy`, `depends_on`: 버킷 정책 속성 및 의존성 설정                                                                                    |
| `s3.tf`                    | AWS S3 버킷 생성                                         | - `resource "aws_s3_bucket" "bucket"`: S3 버킷 생성 선언<br>- `bucket = var.domain_name`: 버킷 이름 지정<br>- `tags`: 버킷 태그 설정                                                                                               |

도메인 이름을 가진 웹 사이트를 위한 인프라를 AWS 상에 구축합니다. 이 과정에는 SSL/TLS 인증서의 관리, 도메인의 DNS 설정, 웹 콘텐츠의 저장 및 전세계 배포가 포함됩니다. Terraform을 통해 이 모든 작업을 코드화함으로써 인프라의 버전 관리, 재사용, 자동화가 가능해집니다.