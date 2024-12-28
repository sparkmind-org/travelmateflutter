import 'package:flutter/material.dart';
import '../models/travel_request.dart';

class TravelRequestCard extends StatefulWidget {
  final TravelRequest request;

  const TravelRequestCard({super.key, required this.request});

  @override
  State<TravelRequestCard> createState() => _TravelRequestCardState();
}

class _TravelRequestCardState extends State<TravelRequestCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => isExpanded = !isExpanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.all(16),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildMainSection(),
                if (isExpanded) ...[
                  const SizedBox(height: 16),
                  _buildExpandedInfo(),
                ],
                const SizedBox(height: 8),
                Center(
                  child: Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.blue.shade300,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainSection() {
    return Column(
      children: [
        // Route Section
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.request.source,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(Icons.arrow_forward, size: 16, color: Colors.grey.shade400),
              Text(
                widget.request.destination,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Details Section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildDetailColumn(
              Icons.calendar_today_outlined,
              widget.request.date,
              widget.request.time,
            ),
            _buildDetailColumn(
              Icons.flight_outlined,
              widget.request.airline ?? 'Indigo',
              widget.request.flightType,
            ),
            _buildDetailColumn(
              Icons.person_outline,
              'Solo',
              '₹ ${widget.request.travelers.length * 10}%',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailColumn(IconData icon, String title, String subtitle) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  // Keeping existing expanded info section unchanged
  Widget _buildExpandedInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const SizedBox(height: 8),
        _buildDetailRow(
          Icons.person,
          'Requester',
          widget.request.name,
        ),
        _buildDetailRow(
          Icons.schedule,
          'Time',
          widget.request.time,
        ),
        _buildDetailRow(
          Icons.flight_class,
          'Flight Type',
          widget.request.flightType,
        ),
        if (widget.request.airline != null)
          _buildDetailRow(
            Icons.airplane_ticket,
            'Airline',
            widget.request.airline!,
          ),
        const SizedBox(height: 12),
        _buildTravelersList(),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTravelersList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Travelers',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 8),
        ...widget.request.travelers.map((traveler) => Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: Colors.blue.shade50,
                child: Text(
                  traveler.name[0].toUpperCase(),
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${traveler.name} (${traveler.gender})',
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        )).toList(),
      ],
    );
  }
}