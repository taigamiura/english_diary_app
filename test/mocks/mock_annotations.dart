import 'package:mockito/annotations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:english_diary_app/repositories/diary_repository.dart';
import 'package:english_diary_app/repositories/api_repository.dart';
import 'package:english_diary_app/repositories/profile_repository.dart';
import 'package:english_diary_app/repositories/ai_correction_repository.dart';
import 'package:english_diary_app/repositories/diary_feedback_repository.dart';
import 'package:english_diary_app/repositories/payment_repository.dart';
import 'package:english_diary_app/repositories/plan_repository.dart';
import 'package:english_diary_app/repositories/subscription_repository.dart';
import 'package:english_diary_app/repositories/auth_repository.dart';
import 'package:english_diary_app/services/diary_service.dart';
import 'package:english_diary_app/services/user_service.dart';
import 'package:english_diary_app/services/ai_correction_service.dart';
import 'package:english_diary_app/services/diary_feedback_service.dart';
import 'package:english_diary_app/services/payment_service.dart';
import 'package:english_diary_app/services/plan_service.dart';
import 'package:english_diary_app/services/subscription_service.dart';

// Repository Mocks
@GenerateMocks([
  DiaryRepository,
  ApiRepository,
  ProfileRepository,
  AiCorrectionRepository,
  DiaryFeedbackRepository,
  PaymentRepository,
  PlanRepository,
  SubscriptionRepository,
  AuthRepository,
])
// Service Mocks
@GenerateMocks([
  DiaryService,
  UserService,
  AiCorrectionService,
  DiaryFeedbackService,
  PaymentService,
  PlanService,
  SubscriptionService,
])
// Supabase Mocks
@GenerateMocks([
  SupabaseClient,
  SupabaseQueryBuilder,
  PostgrestFilterBuilder,
  GoTrueClient,
])
void main() {}
