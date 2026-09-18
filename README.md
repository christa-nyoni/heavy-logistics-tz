# Safari Truck

A Flutter logistics app for Tanzania, combining:

- Bolt-style on-demand city delivery
- Scheduled intercity freight journeys inspired by station-to-station travel
- Heavy-truck transport between an origin and destination
- Guest access using phone OTP verification
- Live trip location sharing with a tracking code
- Driver offer negotiation
- English and Swahili language switching

## Main Services

### Local Delivery

For short city routes using:

- Small Bajaji
- Gutter / Pickup

Users can choose a pickup area, drop-off area, cargo type, cargo weight, budget, and journey date.

### Scheduled Freight

For longer journeys between regions using:

- 10T Rigid Truck
- 28T Semi-Trailer
- 56T Multi-Axle

Users can enter the origin, destination, cargo weight, truck type, target offer, and travel date.

## App Flow

1. Open the onboarding screen.
2. Sign in with an email and password, or continue as a guest.
3. Guest users enter a phone number and verify the demo OTP `123456`.
4. Select a service from the dashboard:
	- Move now
	- Schedule freight
	- Track a live trip
5. Submit a request and review driver offers.
6. Accept an offer or send a counter-offer.
7. Share or view a live trip using the tracking code `TRK-4821`.

## Run The App

Run in Chrome:

```bash
flutter run -d chrome
```

Run tests:

```bash
flutter test
```

Check code quality:

```bash
flutter analyze
```

## Linux Desktop Setup

Linux desktop builds require the native development libraries below:

```bash
sudo apt update
sudo apt install libgcrypt20-dev liblz4-dev g++ libstdc++-12-dev
```

Then run:

```bash
flutter run -d linux
```

## Project Structure

- `lib/main.dart` - app entry point and theme
- `lib/core/constants/` - colors and language strings
- `lib/sreens/auth/` - sign-in, sign-up, password reset, and guest OTP
- `lib/sreens/customer_dashboard/` - main customer dashboard
- `lib/sreens/request_screen/` - local delivery request form
- `lib/sreens/heavy_transport/` - heavy-truck request form
- `lib/sreens/negotiation/` - driver offers and counter-offers
- `lib/sreens/tracking/` - live location and tracking code
- `lib/widgets/app_side_drawer.dart` - main sidebar navigation

## Current Scope

This project is currently a Flutter frontend. It uses simulated driver offers, demo OTP verification, and a map-style live-location view. A production release would need backend authentication, SMS OTP delivery, GPS/location services, maps, driver accounts, and payment integration.
