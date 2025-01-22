// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity.freezed.dart';

part 'activity.g.dart';

enum TimeOfDay {
  any,
  morning,
  afternoon,
  evening,
  night,
}

@freezed
class Activity with _$Activity {
  const factory Activity({
    required String name,
    required String description,
    required String locationName,
    required int duration,
    required TimeOfDay timeOfDay,
    required bool familyFriendly,
    required int price,
    required String destinationRef,
    required String ref,
    required String imageUrl,
  }) = _Activity;

  factory Activity.fromJson(Map<String, Object?> json) =>
      _$ActivityFromJson(json);
}
