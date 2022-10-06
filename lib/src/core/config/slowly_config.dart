
import 'package:get_arch_core/get_arch_core.dart';
import 'package:slowly/slowly.dart';

@module
abstract class SlowlyConfig{
  @dev
  @test
  @prod
  @lazySingleton
  Slowly get slowly => Slowly();
}