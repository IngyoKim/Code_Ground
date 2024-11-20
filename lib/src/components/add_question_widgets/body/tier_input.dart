import 'package:flutter/material.dart';
import 'package:code_ground/src/services/database/datas/tier_data.dart'; // Tier 데이터 import

class TierInput extends StatelessWidget {
  final Tier selectedTier;
  final ValueChanged<Tier?> onTierChanged;

  const TierInput({
    super.key,
    required this.selectedTier,
    required this.onTierChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<Tier>(
        value: selectedTier,
        items: tiers.map((tier) {
          return DropdownMenuItem<Tier>(
            value: tier,
            child: Text(tier.name),
          );
        }).toList(),
        onChanged: onTierChanged,
        decoration: const InputDecoration(
          labelText: 'Select Tier',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
