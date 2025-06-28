import 'package:mockito/annotations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kiwi/repositories/diary_repository.dart';
import 'package:kiwi/repositories/api_repository.dart';
import 'package:kiwi/repositories/profile_repository.dart';
import 'package:kiwi/repositories/ai_correction_repository.dart';
import 'package:kiwi/repositories/diary_feedback_repository.dart';
import 'package:kiwi/repositories/payment_repository.dart';
import 'package:kiwi/repositories/plan_repository.dart';
import 'package:kiwi/repositories/subscription_repository.dart';
import 'package:kiwi/repositories/auth_repository.dart';
import 'package:kiwi/services/diary_service.dart';
import 'package:kiwi/services/user_service.dart';
import 'package:kiwi/services/ai_correction_service.dart';
import 'package:kiwi/services/diary_feedback_service.dart';
import 'package:kiwi/services/payment_service.dart';
import 'package:kiwi/services/plan_service.dart';
import 'package:kiwi/services/subscription_service.dart';

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
