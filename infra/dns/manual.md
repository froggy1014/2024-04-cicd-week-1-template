#### DNS 리소스 배포


```bash
cd ./infra/dns
terraform init
terraform apply -var="profile=YOUR_USER_NAME" -var="domain_name=YOUR_DOMAIN"
```


| 파일명          | 설명                                                                       | 주요 구성 요소                                                                                                                                                                                       |
|-----------------|----------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `_.output.tf`   | AWS Route 53의 DNS 네임서버(NS) 레코드 출력                                | - `aws_route53_zone.zone.name_servers`: Route 53에서 생성된 호스팅 영역의 DNS 네임서버 참조                                                                                                          |
| `_.provider.tf` | AWS 프로바이더 설정                                                        | - `provider "aws"`: AWS 프로바이더 선언<br>- `profile = var.profile`: 사용할 AWS CLI 프로필 지정<br>- `region = var.region`: 사용할 AWS 리전 지정                                                     |
| `_.variables.tf`| 변수 정의                                                                 | - `profile`: AWS CLI 프로필 이름<br>- `region`: AWS 리전, 기본값 "us-east-1"<br>- `domain_name`: 도메인 이름, Route 53 호스팅 영역 및 S3 버킷 설정에 사용                                             |
| `acm_record`    | Route 53 레코드 생성                                                      | - `resource "aws_route53_record" "acm_record"`: Route 53 레코드 생성 선언<br>- `zone_id`, `name`, `type`, `records`, `ttl`: 레코드 속성 설정<br>- `depends_on`: 의존성 설정                           |
| `acm.tf`        | AWS ACM 인증서 생성                                                       | - `resource "aws_acm_certificate" "acm"`: ACM 인증서 생성 선언<br>- `domain_name = var.domain_name`, `validation_method = "DNS"`, `lifecycle`, `depends_on`, `tags`: 인증서 속성 및 설정               |
| `sample.tfvars` | Terraform 변수 값 설정                                                    | - `profile = "edint_official"`, `region = "us-east-1"`, `domain_name = "unchaptered.shop"`: 프로바이더 설정 및 도메인 이름 설정에 필요한 변수 값 지정                                                   |
| `zone.tf`       | Route 53 호스팅 영역 생성                                                 | - `resource "aws_route53_zone" "zone"`: 호스팅 영역 생성 선언<br>- `name = var.domain_name`, `comment = "Created by monthly-cs"`, `tags`: 호스팅 영역 이름, 설명, 태그 설정                            |


