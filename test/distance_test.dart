import 'dart:math';

void main() {
  double lat1a = 46.26096068050625;
  double lon1a = 20.14187178016968;
  double lat2b = 46.26043342317442;
  double lon2b = 20.142918110751065;

  double toRadians(double degree) {
    return degree * pi / 180;
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var cosinus = cos;
    var a = 0.5 -
        cosinus((lat2 - lat1) * p) / 2 +
        cosinus(lat1 * p) *
            cosinus(lat2 * p) *
            (1 - cosinus((lon2 - lon1) * p)) /
            2;

    var result = 12742 * asin(sqrt(a));
    print(result);
    return result;
  }

  calculateDistance(lat1a, lon1a, lat2b, lon2b);

  final R = 6372.8;

  double getHaversineDistance(double lat1, lon1, lat2, lon2) {
    double dLat = toRadians(lat2 - lat1);
    double dLon = toRadians(lon2 - lon1);
    lat1 = toRadians(lat1);
    lat2 = toRadians(lat2);
    double a =
        pow(sin(dLat / 2), 2) + pow(sin(dLon / 2), 2) * cos(lat1) * cos(lat2);
    double c = 2 * asin(sqrt(a));
    var result2 = R * c;
    print(result2);
    return result2;
  }

  getHaversineDistance(lat1a, lon1a, lat2b, lon2b);

  double getVincentyDistance(
      double lat1, double lon1, double lat2, double lon2) {
    double a = 6378137, b = 6356752.314245, f = 1 / 298.257223563;

    double L = toRadians(lon2 - lon1);

    double lambda = L, lambdaP, iterLimit = 100;

    double U1 = atan((1 - f) * tan(toRadians(lat1)));

    double U2 = atan((1 - f) * tan(toRadians(lat2)));

    double sinU1 = sin(U1), cosU1 = cos(U1);

    double sinU2 = sin(U2), cosU2 = cos(U2);

    double cosSqAlpha, sinSigma, cos2SigmaM, cosSigma, sigma;

    do {
      double sinLambda = sin(lambda), cosLambda = cos(lambda);

      sinSigma = sqrt((cosU2 * sinLambda) * (cosU2 * sinLambda) +
          (cosU1 * sinU2 - sinU1 * cosU2 * cosLambda) *
              (cosU1 * sinU2 - sinU1 * cosU2 * cosLambda));

      if (sinSigma == 0) return 0;

      cosSigma = sinU1 * sinU2 + cosU1 * cosU2 * cosLambda;

      sigma = atan2(sinSigma, cosSigma);

      double sinAlpha = cosU1 * cosU2 * sinLambda / sinSigma;

      cosSqAlpha = 1 - sinAlpha * sinAlpha;

      cos2SigmaM = cosSigma - 2 * sinU1 * sinU2 / cosSqAlpha;

      double C = f / 16 * cosSqAlpha * (4 + f * (4 - 3 * cosSqAlpha));

      lambdaP = lambda;

      lambda = L +
          (1 - C) *
              f *
              sinAlpha *
              (sigma +
                  C *
                      sinSigma *
                      (cos2SigmaM +
                          C * cosSigma * (-1 + 2 * cos2SigmaM * cos2SigmaM)));
    } while ((lambda - lambdaP).abs() > 1e-12 && --iterLimit > 0);

    if (iterLimit == 0) return 0;

    double uSq = cosSqAlpha * (a * a - b * b) / (b * b);

    double A =
        1 + uSq / 16384 * (4096 + uSq * (-768 + uSq * (320 - 175 * uSq)));

    double B = uSq / 1024 * (256 + uSq * (-128 + uSq * (74 - 47 * uSq)));

    double deltaSigma = B *
        sinSigma *
        (cos2SigmaM +
            B /
                4 *
                (cosSigma * (-1 + 2 * cos2SigmaM * cos2SigmaM) -
                    B /
                        6 *
                        cos2SigmaM *
                        (-3 + 4 * sinSigma * sinSigma) *
                        (-3 + 4 * cos2SigmaM * cos2SigmaM)));

    double s = b * A * (sigma - deltaSigma);
    print(s * 0.001);
    return s * 0.001;
  }

  getVincentyDistance(lat1a, lon1a, lat2b, lon2b);
  var magnitude = const Point(10, 10).magnitude;
  print(magnitude);
}
